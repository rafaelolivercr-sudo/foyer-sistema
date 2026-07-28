FROM nginx:alpine

# Build args to set admin credentials (override at build time)
ARG ADMIN_USER=admin
ARG ADMIN_PASS=admin

# Install htpasswd tool and create htpasswd file
RUN apk add --no-cache httpd-tools \
	&& htpasswd -bc /etc/nginx/.htpasswd "$ADMIN_USER" "$ADMIN_PASS"

# Copy nginx config and site
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
