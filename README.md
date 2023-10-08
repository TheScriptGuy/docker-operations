# Bash scripts for docker :whale:

Managing docker shouldn't have to be hard.

I've written some bash scripts to help gather information from the containers running on the host.
These scripts need to be run on teh host that's running the docker daemon.

## containers_exited_days.sh
In an effort to help minimize the operational bloat that comes from managing many containers. This bash script will help identify containers that have exited after a certain number of defined days.

To show the containers that have exited more than 90 days ago.
```bash
$ containers_exited_days 90
Images with containers exited more than 90 day(s) ago:
- prod1/container1 (Container ID: aea9a8314cbd, Status: Exited (137) 12 months ago)
- dev1/container2 (Container ID: b3c73292fb7f, Status: Exited (137) 2 years ago)
- qa/container3 (Container ID: 3411624e70ac1, Status: Exited (130) 2 years ago)
```

## container_ip_addresses.sh
A bash script will list all the IP addresses and networks that each container exists in.

```bash
$ container_ip_addresses.sh
container1                          inside_network  192.168.1.4
container2                          dmz             192.168.2.105
container3                          dmz             192.168.2.120
container4                          dmz             192.168.2.100
```
