function awsmfa {
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECURITY_TOKEN

    serial_number=${AWS_MFA_SERIAL_NUMBER}
    if [[ "x${1}" == "x" ]]; then
        echo "Usage: awsmfa <MFA code>"
        exit 1
    fi

    creds=$(aws sts get-session-token --serial-number $serial_number --output text --token-code $1)

    access_key_id=$(echo $creds | awk '{ print $2 }')
    expiration=$(echo $creds | awk '{ print $3 }')
    secret_access_key=$(echo $creds | awk '{ print $4 }')
    session_token=$(echo $creds | awk '{ print $5 }')

    export AWS_ACCESS_KEY_ID=${access_key_id}
    export AWS_SECRET_ACCESS_KEY=${secret_access_key}
    export AWS_SECURITY_TOKEN=${session_token}

    echo export AWS_ACCESS_KEY_ID=${access_key_id} > ~/.aws/session-creds
    echo export AWS_SECRET_ACCESS_KEY=${secret_access_key} >> ~/.aws/session-creds
    echo export AWS_SECURITY_TOKEN=${session_token} >> ~/.aws/session-creds

    echo "Expiration: " $expiration
}
