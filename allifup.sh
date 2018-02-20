ip -o link | while read line
do
  t=`echo $line | sed -e "s/^[^:]\+: \([^:]\+\):.*/\1/"`
  if [ $t != "lo" ];then
    ip link set dev $t up
    dhcpcd $t
  fi
done
