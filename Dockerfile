# Frozen static archive of newsletter.margotbrun.com.
# The SPA was built once, snapshotted/rebuilt to plain static HTML, and is
# served by a current nginx. There is no build step here — it just copies the
# pre-rendered static site. See README.md for how the site was produced.
FROM nginx:alpine

# Clean-route config (maps /oiseaux -> oiseaux.html, etc.)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Pre-rendered static site (HTML + vendored CSS/fonts + media)
COPY site/ /usr/share/nginx/html/
