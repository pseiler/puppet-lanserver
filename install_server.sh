#!/bin/bash

## Setting neccessary variables
HERE="$(dirname "$(readlink -f "${0}")")";

## Set this according to your puppet modules directory
## shipped with your puppet installation
PUPPET_MODULE_PATH="/usr/share/puppet/modules/";


centos_requirements(){
    if ! rpm -qa | grep -q "puppet-agent\|puppetlabs-stdlib";
    then
        if ! rpm -qa | grep -q "epel-release-latest\|puppet5-release";
        then
            yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${DISTRO_VERSION}.noarch.rpm https://yum.puppetlabs.com/puppet5/puppet5-release-el-${DISTRO_VERSION}.noarch.rpm" git;
        fi
        yum install -y "puppet-agent" "puppetlabs-stdlib";
    fi;
    if [ -f /etc/profile.d/puppet.sh ];
    then
        if ! which puppet > /dev/null;
        then
            source /etc/profile.d/puppet.sh;
        fi;
    else
        # Creating search path for puppet binary for bash
        echo "#!/bin/bash" > /etc/profile.d/puppet.sh;
        echo "PATH=\"\${PATH}:/opt/puppetlabs/puppet/bin\"" >> /etc/profile.d/puppet.sh;
    fi;
}
suse_requirements(){
    local PUPPET5_REPO="https://yum.puppetlabs.com/puppet5/sles/15/x86_64/"
    local PUPPETLABS_REPO="https://download.opensuse.org/repositories/home:/seilerphilipp:/puppet/openSUSE_Leap_15.1/"
    local OPENTRACKER_REPO="https://download.opensuse.org/repositories/home:/seilerphilipp:/opentracker/openSUSE_Leap_15.1/"
    if ! rpm -qa | grep -q "puppet-agent";
    then
        if ! zypper repos --uri | grep -qi "${PUPPET5_REPO}";
        then
            zypper addrepo -f "${PUPPET5_REPO}" "puppet5";
        fi;
        zypper install -y "puppet-agent";
    fi;
    if ! rpm -qa | grep -q "puppetlabs-stdlib";
    then
        if ! zypper repos --uri | grep -qi "${PUPPETLABS_REPO}";
        then
            zypper addrepo -f "${PUPPETLABS_REPO}" "puppetlabs";
        fi
	zypper --gpg-auto-import-keys refresh
        zypper install -y "puppetlabs-stdlib";
    fi;
    if ! rpm -qa | grep -q "opentracker";
    then
        if ! zypper repos --uri | grep -qi "${OPENTRACKER_REPO}";
        then
            zypper addrepo -f "${OPENTRACKER_REPO}" "opentracker";
        fi
	zypper --gpg-auto-import-keys refresh
    fi;
    if [ -f /etc/profile.d/puppet.sh ];
    then
        if ! which puppet &> /dev/null;
        then
            source /etc/profile.d/puppet.sh;
        fi;
    else
        # Creating search path for puppet binary for bash
        echo "#!/bin/bash" > /etc/profile.d/puppet.sh;
        echo "PATH=\"\${PATH}:/opt/puppetlabs/puppet/bin\"" >> /etc/profile.d/puppet.sh;
    fi;
}

if [ $UID -ne 0 ];
then
    echo "run the script as root";
    exit 1;
fi;

# get distribution
if [ -e "/etc/os-release" ];
then
    DISTRO=$(grep "^ID=" "/etc/os-release" | cut -d"=" -f2| sed 's/"//g');
    DISTRO_VERSION=$(grep "^VERSION_ID=" "/etc/os-release" | cut -d"=" -f2);
else
    echo "Linux distribution not found.";
    echo "Maybe the file \"/etc/os-release\" is just missing.";
    echo "Or your linux distribution is too old.";
    exit 1;
fi;


### checking if distribution is fupported.
### Preparing everything every repo to deploy puppet code and install rpms.
case "${DISTRO}" in
    centos|redhat)
        centos_requirements
        ;;
    opensuse-leap)
        suse_requirements
        ;;
    *)
        echo "The distribution \"${DISTRO}\" is not supported.";
        echo "Sorry.";
        exit 1;
        ;;
esac;





# Creating search path for puppet binary for csh
if [ ! -e /etc/profile.d/puppet.csh ];
then
    echo "#!/bin/csh" > /etc/profile.d/puppet.csh;
    echo "PATH=\"\${PATH}:/opt/puppetlabs/puppet/bin\"" >> /etc/profile.d/puppet.csh;
fi;

# checkout submodules when git is used
if [ -d ${HERE}/.git ]
then
    git submodule update --init;
fi

# check for puppet binary
if [ ! -e "$(which puppet)" ];
then
    echo '"puppet" binary not found.';
    exit 1;
fi;

## apply the actual puppet code
# set the module path so puppet apply finds every module
puppet apply --modulepath="${PUPPET_MODULE_PATH}:${HERE}" -e "include lanserver";

#handle return code
if [ $? -eq 0 ];
then
    echo "";
    echo -e "\e[32mSUCCESS\e[39m.";
    echo "";
    echo "Rerun the script to apply changes made in the \"params.pp\" of the puppet module.";
    echo "Now you can also us the following command to update your server without running this script:";
    echo "puppet apply --modulepath=${PUPPET_MODULE_PATH}:${HERE} -e \"include lanserver\"";
else
    echo "";
    echo -e "\e[31mERROR\e[39m:";
    echo "";
    echo "Please check the output of the puppet run above. Most of the errors can be fixed easily";
    exit 1;
fi
