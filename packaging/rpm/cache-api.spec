Name:           cache-api
Version:        1.0.0
Release:        1
Summary:        Caching proxy API for the practice project
License:        Unspecified
BuildArch:      noarch

Source0:        cache-api.py
Source1:        config-api.yaml
Source2:        cache-api.service

BuildRequires:  python3

Requires:       python3
Requires:       python3-flask
Requires:       python3-redis
Requires:       python3-requests
Requires:       python3-pyyaml
Requires:       systemd

%description
Python HTTP proxy that reads user data from the backend
and caches successful responses in Redis.

%install
install -D -m 0644 %{SOURCE0} %{buildroot}/usr/libexec/cache-api/cache-api.py
install -D -m 0644 %{SOURCE1} %{buildroot}/etc/cache-api/config.yaml
install -D -m 0644 %{SOURCE2} %{buildroot}/usr/lib/systemd/system/cache-api.service

%check
/usr/bin/python3 -m py_compile %{SOURCE0}

%files
%defattr(-,root,root,-)
/usr/libexec/cache-api/
%dir /etc/cache-api
%config(noreplace) /etc/cache-api/config.yaml
/usr/lib/systemd/system/cache-api.service
