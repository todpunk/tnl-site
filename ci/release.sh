#!/usr/bin/env bash

touch runnerenv.sh
echo "REACTORCIDE_JOB_REPO_URL=${REACTORCIDE_JOB_REPO_URL}" >> runnerenv.sh

touch jobenv.sh
echo "REACTORCIDE_JOB_ENTRYPOINT=${REACTORCIDE_JOB_ENTRYPOINT}" >> jobenv.sh
echo "CI_KUBECONFIG=\"${CI_KUBECONFIG}\"" >> jobenv.sh

touch cisshkey
echo "${CI_SSH_KEY}" >> cisshkey
chmod 600 cisshkey
scp -i cisshkey -o "StrictHostKeyChecking=no" -P ${CI_HOST_PORT} runnerenv.sh jobenv.sh ${CI_HOST_USER}@${CI_HOST_ADDRESS}:~/
# external-root.sh should already exist per reactorcide requirements
ssh ${CI_HOST_USER}@${CI_HOST_ADDRESS} -i cisshkey -o "StrictHostKeyChecking=no" -p ${CI_HOST_PORT} ./external-root.sh

