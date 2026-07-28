# foyer-sistema

Deployment options
------------------

1) GitHub Pages (recommended for static sites)

 - The repository includes a GitHub Actions workflow at `.github/workflows/deploy-pages.yml` that deploys the site to GitHub Pages on push to `main`.

2) Docker (run anywhere with Docker)

 Build and run locally:

 ```bash
 # Example: set admin user/pass at build time (recommended)
 docker build --build-arg ADMIN_USER=admin --build-arg ADMIN_PASS="s3nh4segura" -t foyer-sistema:latest .
 docker run -p 8080:80 foyer-sistema:latest
 # then open http://localhost:8080
 ```

If you want, I can commit and push these files to the remote; or create a branch and open a pull request. Which do you prefer?

Production: secure admin credentials
----------------------------------

Do not bake plaintext admin credentials into images or commit them to the repository. Recommended options to manage the HTTP Basic `htpasswd` file in production:

- Generate the `htpasswd` file outside the build (on a secure admin machine):

```bash
# install htpasswd utility (Debian/Ubuntu)
sudo apt-get install apache2-utils
# create bcrypt-hashed htpasswd and add user 'admin'
htpasswd -cB ./htpasswd admin
```

- Mount the `htpasswd` file at runtime (Docker) instead of generating at build time:

```bash
docker build -t foyer-sistema:prod .
docker run -p 8080:80 -v $(pwd)/htpasswd:/etc/nginx/.htpasswd:ro foyer-sistema:prod
```

- Example `docker-compose.yml` snippet:

```yaml
version: '3.8'
services:
	web:
		image: foyer-sistema:prod
		ports:
			- '80:80'
		volumes:
			- ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
			- ./htpasswd:/etc/nginx/.htpasswd:ro
```

- Kubernetes (create secret and mount as file):

```bash
kubectl create secret generic htpasswd --from-file=htpasswd=./htpasswd
# then mount the secret as a file at /etc/nginx/.htpasswd in the Pod spec
```

- CI / automated builds: use repository secrets / environment secrets rather than embedding credentials in the image. If you must create the file during CI, write it to a secure artifact storage and avoid printing secrets in logs.

Security note: prefer strong hashed passwords (bcrypt) and rotate credentials periodically. Do not store `htpasswd` in the repo or in public places.
