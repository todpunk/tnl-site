let pagefindReady = null;

function getPagefind() {
    if (pagefindReady === null) {
        pagefindReady = import("/search/pagefind/pagefind.js").then(async (pagefind) => {
            await pagefind.options({ baseUrl: "/" });
            await pagefind.init();
            return pagefind;
        });
    }
    return pagefindReady;
}

function resultItem(item) {
    const entry = document.createElement("li");
    const link = document.createElement("a");
    const excerpt = document.createElement("p");

    link.href = item.url;
    link.textContent = item.meta.title || item.url;
    excerpt.innerHTML = item.excerpt;
    entry.append(link, excerpt);
    return entry;
}

for (const component of document.querySelectorAll("[data-search-component]")) {
    const form = component.querySelector("[data-search-form]");
    const input = form.querySelector("input[name='q']");
    const output = component.querySelector("[data-search-output]");
    const status = component.querySelector("[data-search-status]");
    const results = component.querySelector("[data-search-results]");
    const more = component.querySelector("[data-search-more]");
    const limit = Number.parseInt(form.dataset.searchLimit, 10);
    let generation = 0;
    let timer = null;

    async function run() {
        const current = ++generation;
        const query = input.value.trim();

        if (query === "") {
            results.replaceChildren();
            status.textContent = "";
            output.hidden = true;
            if (form.hasAttribute("data-search-url")) {
                const url = new URL(window.location);
                url.searchParams.delete("q");
                history.replaceState(null, "", url);
            }
            return;
        }

        output.hidden = false;
        status.textContent = "Searching…";
        if (more) {
            more.href = `/search/?q=${encodeURIComponent(query)}`;
        }
        if (form.hasAttribute("data-search-url")) {
            const url = new URL(window.location);
            url.searchParams.set("q", query);
            history.replaceState(null, "", url);
        }

        try {
            const pagefind = await getPagefind();
            const search = await pagefind.search(query);
            if (current !== generation) {
                return;
            }

            const found = await Promise.all(
                search.results.slice(0, limit).map((result) => result.data())
            );
            if (current !== generation) {
                return;
            }

            const count = search.results.length;
            status.textContent = `${count} ${count === 1 ? "result" : "results"}`;
            results.replaceChildren(...found.map(resultItem));
        } catch (error) {
            if (current === generation) {
                results.replaceChildren();
                status.textContent = "Search failed. Reload the page and try again.";
                console.error(error);
            }
        }
    }

    form.addEventListener("submit", (event) => {
        event.preventDefault();
        run();
    });

    input.addEventListener("input", () => {
        clearTimeout(timer);
        timer = setTimeout(run, 120);
    });

    if (form.hasAttribute("data-search-url")) {
        const initial = new URLSearchParams(window.location.search).get("q");
        if (initial) {
            input.value = initial;
            run();
        }
    }
}
