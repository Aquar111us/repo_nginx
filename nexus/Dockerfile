FROM rockylinux:8 as repo_nginx
RUN yum install yum-utils createrepo curl -y
RUN rm -rf /etc/yum.repos.d/*
COPY ./*.repo /etc/yum.repos.d/
RUN mkdir /opt/{7..8,86}
RUN yumdownloader "*dab*" "*fintech*" "*auth*" "*sso*"  "*quality*" --releasever=7 --enablerepo=dab7 --destdir /opt/7/ && cd /opt/7/ && createrepo_c .
RUN yumdownloader "*dab*" "*fintech*" "*auth*" "*sso*" "*pwquality*" "*pszv*"  --releasever=8 --enablerepo=dab8 --destdir /opt/8/ && cd /opt/8/ && createrepo_c .
RUN yumdownloader "*dab*" "*fintech*" "*auth*" "*sso*" "*pwquality*" "*pszv*"  --releasever=8.6 --enablerepo=dab86 --destdir /opt/86/ && cd /opt/86/ && createrepo_c .