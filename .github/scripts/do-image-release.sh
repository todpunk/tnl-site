#!/usr/bin/env bash

set -e

THISSCRIPT=$(basename $0)

DRYRUN="false"
RELEASED_CHANGES="false"

GITHUB_OUTPUT=${GITHUB_OUTPUT:-$(mktemp)}

# Modify for the help message
usage() {
  echo "${THISSCRIPT} command"
  echo "Executes the step command in the script."
  exit 0
}

fullrun() {

  # Build the semver-tags command based on inputs
  COMMAND_STRING="./semver-tags run " # --github_action "
  if [[ "${DRYRUN}" == "true" ]]; then
    COMMAND_STRING+="--dry_run "
  fi

  RESULT=$($COMMAND_STRING)

  # Parse the results out to get the versions we need to update and the release notes
  PUBLISHED=$(yq -P ".New_release_published" <<< $RESULT)
  NEW_TAG=$(yq -P ".New_release_git_tag" <<< $RESULT)
  LAST_VERSION=$(yq -P ".Last_release_version" <<< $RESULT)
  JSON_RELEASE_NOTES=$(yq -P ".New_release_notes_json" <<< $RESULT)
  RUNDATE=$(date +"%Y-%m-%d-%T")

  # This makes a run specific release not json file
  # this will also be added only if there's a version to change

  
  # Update the version in the VERSION.txt file if needed
  if [[ "${PUBLISHED_ARRAY[i]}" == "false" ]]; then
    echo "No new version to publish"
    exit 0
  fi
  # If we're here, we have a thing to publish
  RELEASED_CHANGES="true"

  echo "Last Version: ${LAST_VERSION}"
  echo "New Tag: ${NEW_TAG}"
  NEW_VERSION=${NEW_TAG#*v}
  echo "New Version: ${NEW_VERSION}"

  # Now update all the things
  # We use the "ci:" prefix because it doesn't count as a version bump
  # but we do need to tag all these and commit the changes. We could break this up to a second loop I guess.
  if [[ "${DRYRUN}" == "true" ]]; then
    echo "Would be changing version $LAST_VERSION to $NEW_VERSION in content/extra_files/VERSION.txt"
    echo "Would run :"
    echo " > git add \"content/extra_files/VERSION.txt\""
    echo " > git commit -m \"ci: adding version ${NEW_TAG} to content/extra_files/VERSION.txt\""
  else
    echo "Changing version $LAST_VERSION to $NEW_VERSION in content/extra_files/VERSION.txt"
    # replace the version in the VERSION.txt file
    sed -i "s/.*/${NEW_VERSION}/" "content/extra_files/VERSION.txt"
    git add "content/extra_files/VERSION.txt"
    git commit -m "ci: adding version ${NEW_TAG} to content/extra_files/VERSION.txt"
  fi
  
  if [[ "${DRYRUN}" == "true" ]]; then
    echo "Would git push here"
  else
    # We only want to push if we have released something. This also makes the whole operation idempotent
    # so it can be rerun and the git state will be updated without breaking future runs
    if [[ "${RELEASED_CHANGES}" == "true" ]]; then
      git push
    fi
  fi

  echo "RELEASED_CHANGES=${RELEASED_CHANGES}"
  echo "NEW_VERSION=${NEW_VERSION}"

  echo "RELEASED_CHANGES=${RELEASED_CHANGES}" >> $GITHUB_OUTPUT
  echo "NEW_VERSION=${NEW_VERSION}" >> $GITHUB_OUTPUT
}

dryrun() {
  DRYRUN="true"
  fullrun "$@"
}

# This should be last in the script, all other functions are named beforehand.
case "$1" in
  "dryrun")
    shift
    dryrun "$@"
    ;;
  "fullrun")
    shift
    fullrun "$@"
    ;;
  *)
    usage
    ;;
esac

exit 0