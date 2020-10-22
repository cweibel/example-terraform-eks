cf api --skip-ssl-validation "https://api.${system_domain}"

admin_pass=$(kubectl get secret \
        --namespace kubecf var-cf-admin-password \
        -o jsonpath='{.data.password}' \
        | base64 --decode)

cf auth admin "$${admin_pass}"

cf create-org my-org

cf create-space my-space -o my-org

cf target -o my-org -s my-space