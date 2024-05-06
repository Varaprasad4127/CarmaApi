FROM nginx:1.10.1-alpine
# COPY C:\Users\Varam\OneDrive\Desktop\.vscode\.vscode\CodeBase\index.html /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]