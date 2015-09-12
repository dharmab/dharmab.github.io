disable_iptables:
  service.dead:
    - name: iptables
    - enable: False
