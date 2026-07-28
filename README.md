# foyer-sistema

Deployment options
------------------

1) GitHub Pages (recommended for static sites)

 - The repository includes a GitHub Actions workflow at `.github/workflows/deploy-pages.yml` that deploys the site to GitHub Pages on push to `main`.

2) Docker (run anywhere with Docker)

 Build and run locally:

 ```bash
 docker build -t foyer-sistema:latest .
 docker run -p 8080:80 foyer-sistema:latest
 # then open http://localhost:8080
 ```

If you want, I can commit and push these files to the remote; or create a branch and open a pull request. Which do you prefer?
