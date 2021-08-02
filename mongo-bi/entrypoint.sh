#!/usr/bin/env /bin/bash

service rsyslog start

VERBOSE="${VERBOSE:=1}"

CONFIG_MONGO_BI_ADDR="${CONFIG_MONGO_BI_ADDR:=0.0.0.0:3307}"
CONFIG_MONGO_BI_LOG_PATH="${CONFIG_MONGO_BI_LOG_PATH:=/dev/stderr}"
CONFIG_MONGO_BI_LOG_APPEND="${CONFIG_MONGO_BI_LOG_APPEND:=1}"
CONFIG_MONGO_BI_LOG_ROTATE="${CONFIG_MONGO_BI_LOG_ROTATE:=reopen}"

# Based on https://docs.mongodb.com/bi-connector/current/reference/mongosqld/#command-line-options
declare -A CLI_OPTS=( 
    # Core Options
    ['CONFIG_MONGO_BI_ADDR']='--addr'
    ['CONFIG_MONGO_BI_VERSION']='flag:--version'
    ['CONFIG_MONGO_BI_CONFIG']='--config'
    ['CONFIG_MONGO_BI_MONGO_URI']='--mongo-uri'
    ['CONFIG_MONGO_BI_MONGO_VERSION_COMPATIBILITY']='--mongo-versionCompatibility'
    ['CONFIG_MONGO_BI_MAX_VARCHAR_LENGTH']='--maxVarcharLength'
    ['CONFIG_MONGO_BI_MONGO_USERNAME']='--mongo-username'
    ['CONFIG_MONGO_BI_MONGO_PASSWORD']='--mongo-password'
    ['CONFIG_MONGO_BI_MONGO_AUTHENTIFICATION_SOURCE']='--mongo-authenticationSource'
    ['CONFIG_MONGO_BI_MONGO_AUTHENTIFICATION_MECHANISM']='--mongo-authenticationMechanism'
    # Schema Options
    ['CONFIG_MONGO_BI_SCHEMA']='--schema'
    ['CONFIG_MONGO_BI_SCHEMA_DIRECTORY']='--schemaDirectory'
    ['multiple:CONFIG_MONGO_BI_SAMPLE_NAMESPACES']='--sampleNamespaces'
    ['CONFIG_MONGO_BI_SAMPLE_NAMESPACES']='--sampleNamespaces'
    ['CONFIG_MONGO_BI_SCHEMA_MODE']='--schemaMode'
    ['CONFIG_MONGO_BI_SCHEMA_SOURCE']='--schemaSource'
    ['CONFIG_MONGO_BI_SCHEMA_NAME']='--schemaName'
    ['CONFIG_MONGO_BI_SAMPLE_SIZE']='--sampleSize'
    ['CONFIG_MONGO_BI_SCHEMA_REFRESH_INTERVAL_SECS']='--schemaRefreshIntervalSecs'
    ['CONFIG_MONGO_BI_UUID_SUBTYPE3_ENCODING']='--uuidSubtype3Encoding'
    ['CONFIG_MONGO_BI_PREJOIN']='flag:--prejoin'
    # Log Options
    ['CONFIG_MONGO_BI_LOG_APPEND']='flag:--logAppend'
    ['CONFIG_MONGO_BI_LOG_PATH']='--logPath'
    ['CONFIG_MONGO_BI_LOG_ROTATE']='--logRotate'
    ['CONFIG_MONGO_BI_USAGE_LOG_INTERVAL']='--usageLogInterval'
    ['CONFIG_MONGO_BI_VERBOSE']='flag:--verbose'
    ['CONFIG_MONGO_BI_VERY_VERBOSE']='flag:-vv'
    # MongoDB TLS/SSL Options
    ['CONFIG_MONGO_BI_MONGO_SSL']='flag:--mongo-ssl'
    ['CONFIG_MONGO_BI_MONGO_SSL_PEM_KEY_FILE']='--mongo-sslPEMKeyFile'
    ['CONFIG_MONGO_BI_MONGO_SSL_PEM_KEY_PASSWORD']='--mongo-sslPEMKeyPassword'
    ['CONFIG_MONGO_BI_MONGO_SSL_ALLOW_INVALID_HOSTNAMES']='flag:--mongo-sslAllowInvalidHostnames'
    ['CONFIG_MONGO_BI_MONGO_SSL_ALLOW_INVALID_CERTIFICATES']='flag:--mongo-sslAllowInvalidCertificates'
    ['CONFIG_MONGO_BI_MONGO_SSL_CA_FILE']='--mongo-sslCAFile'
    ['CONFIG_MONGO_BI_MONGO_SSL_CRL_FILE']='--mongo-sslCRLFile'
    ['CONFIG_MONGO_BI_MONGO_SSL_FIPS_MODE']='flag:--mongo-sslFIPSMode'
    ['CONFIG_MONGO_BI_MONGO_MINIMUM_TLS_VERSION']='--mongo-minimumTLSVersion'
    # Client TLS/SSL Options
    ['CONFIG_MONGO_BI_SSL_MODE']='--sslMode'
    ['CONFIG_MONGO_BI_SSL_PEM_KEY_FILE']='--sslPEMKeyFile'
    ['CONFIG_MONGO_BI_SSL_PEM_KEY_PASSWORD']='--sslPEMKeyPassword'
    ['CONFIG_MONGO_BI_SSL_ALLOW_INVALID_HOSTNAMES']='flag:--sslAllowInvalidHostnames'
    ['CONFIG_MONGO_BI_SSL_ALLOW_INVALID_CERTIFICATES']='flag:--sslAllowInvalidCertificates'
    ['CONFIG_MONGO_BI_SSL_CA_FILE']='--sslCAFile'
    ['CONFIG_MONGO_BI_SSL_CRL_FILE']='--sslCRLFile'
    ['CONFIG_MONGO_BI_AUTH']='flag:--auth'
    ['CONFIG_MONGO_BI_DEFAULT_AUTH_SOURCE']='--defaultAuthSource'
    ['CONFIG_MONGO_BI_DEFAULT_AUTH_MECHANISM']='--defaultAuthMechanism'
    ['CONFIG_MONGO_BI_MINIMUM_TLS_VERSION']='--minimumTLSVersion'
    # Service Options
    ['CONFIG_MONGO_BI_SERVICE_NAME']='--serviceName'
    ['CONFIG_MONGO_BI_SERVICE_DISPLAY_NAME']='--serviceDisplayName'
    ['CONFIG_MONGO_BI_SERVICE_DESCRIPTION']='--serviceDescription'
    # Kerberos Options
    ['CONFIG_MONGO_BI_GSS_API_HOSTNAME']='--gssapiHostname'
    ['CONFIG_MONGO_BI_GSS_API_SERVICE_NAME']='--gssapiServiceName'
    ['CONFIG_MONGO_BI_MONGO_GSS_API_SERVICE_NAME']='--mongo-gssapiServiceName'
    ['CONFIG_MONGO_BI_GSS_API_CONSTRAINED_DELEGATION']='--gssapiConstrainedDelegation'
    # Socket Options
    ['CONFIG_MONGO_BI_FILE_PERMISSIONS']='--filePermissions'
    ['CONFIG_MONGO_BI_NO_UNIX_SOCKET']='flag:--noUnixSocket'
    ['CONFIG_MONGO_BI_UNIX_SOCKET_PREFIX']='--unixSocketPrefix'
    # Set Parameter Option
    ['CONFIG_MONGO_BI_SET_PARAMETER']='--setParameter'
)


params=()

function add_param() {
    # add_param <arg_name (value in CLI_OPTS)> <value>
    # add a param to the global 
    arg_name="$1"
    value="$2"
    if [[ $arg_name == flag:* ]] ; then
        new_arg=$(echo $arg_name | cut -c6-)
    else
        new_arg="${arg_name} ${value}"
    fi
    params+=($new_arg)
}

for env_name in "${!CLI_OPTS[@]}"; do 

    # Handle case where we can have multiple params with the same name but different values
    # Example
    # CONFIG_MONGO_BI_SAMPLE_NAMESPACES_1=toto
    # CONFIG_MONGO_BI_SAMPLE_NAMESPACES_1=tata
    # will generate
    # mongosql --sampleNamespaces toto --sampleNamespaces tata
    if [[ $env_name == multiple:* ]] ; then
        arg_name="${CLI_OPTS[$env_name]}"
        original_env_name=$env_name

        # Override env_name to the version without multiple: prefix
        env_name=$(echo $env_name | cut -c10-)
        
        x=1
        multiple_env_name=${env_name}_${x}
        while [[ ! -z "${!multiple_env_name}" ]]
        do
            add_param ${CLI_OPTS[$original_env_name]} ${!multiple_env_name}
            [ $VERBOSE -eq 1 ] && echo "$multiple_env_name set, add ${CLI_OPTS[$original_env_name]} to cli"
            
            x=$(( $x + 1 ))
            multiple_env_name=${env_name}_${x}
        done

        continue
    fi

    # Handle simple clase of env var (without)
    if [ ! -z "${!env_name}" ] ; then
        add_param ${CLI_OPTS[$env_name]} ${!env_name}
        [ $VERBOSE -eq 1 ] && echo "$env_name set, add ${!env_name} to cli"
    else
        [ $VERBOSE -eq 1 ] && echo "$env_name not set or empty"
    fi
done

[ $VERBOSE -eq 1 ] && echo "-----------------"
[ $VERBOSE -eq 1 ] && echo "mongosqld ${params[@]}"
[ $VERBOSE -eq 1 ] && echo "..."

mongosqld "${params[@]}"