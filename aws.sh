#!/bin/bash

aws_ssm() {
    OPTIND=1
    local options=":p:r:"

    while getopts $options opt; do
        case $opt in
            p)
                local aws_profile=$OPTARG
                ;;
            r)
                local aws_region=$OPTARG
                ;;
            \?)
                stderr Usage: $prog [ $options ]
                exit 2
                ;;
        esac
    done

    shift $((OPTIND - 1))

    local aws_profile=${aws_profile:-dataworks-development}
    local aws_region=${aws_region:-eu-west-2}

    local aws_ec2_instance_name=${1:?Usage: $FUNCNAME aws-ec2-instance-name}

    local instance_id=$(aws_ec2_instance_id \
                            -p $aws_profile \
                            -r $aws_region $aws_ec2_instance_name | tr -d '"')

    if [[ -n $instance_id ]] && [[ $instance_id != 'null' ]]; then
        aws ssm start-session --target $instance_id \
            --profile $aws_profile --region $aws_region
    else
        echo $FUNCNAME: no instance id returned for \'$aws_ec2_instance_name\'.
        return 1
    fi
}

aws_ec2_instance_id() {

    OPTIND=1
    local options=":p:r:"

    while getopts $options opt; do
        case $opt in
            p)
                local aws_profile=$OPTARG
                ;;
            r)
                local aws_region=$OPTARG
                ;;
            \?)
                stderr Usage: $prog [ $options ]
                exit 2
                ;;
        esac
    done

    shift $((OPTIND - 1))

    local aws_profile=${aws_profile:-dataworks-development}
    local aws_region=${aws_region:-eu-west-2}

    local aws_ec2_instance_name=${1:?Usage: $FUNCNAME aws-ec2-instance-name}

    aws ec2 \
        --profile=$aws_profile \
        --region=$aws_region \
        describe-instances \
        --filters="Name=tag-value,Values=$aws_ec2_instance_name" \
        --query "Reservations[0].Instances[0].InstanceId"
}
