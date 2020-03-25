npm run build
tar -cvf public.tar.gz ./public
scp public.tar.gz root@182.254.204.253:/usr/local/nginx