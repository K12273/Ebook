#设备名模式匹配串
DEVICEPATTERN="^[a-z]d[a-z]$"
#读取需要挂载的设备名
function read_dirname ()
{
  devname=""
  while ! [[ "$devname" =~ $DEVICEPATTERN ]]
  do
    read -p "请输入需要格式化和挂载的磁盘,(如:vdc):" devname
  done
}
#读取挂载点
function read_mountdir ()
{
  mountdir=""
  while [ ! -d "$mountdir" ]
    do
    read -p "请输入磁盘挂载点,(如:/opt):" mountdir
    if [ ! -d "$mountdir" ]
    then
      echo "挂载点目录不存在,请重新输入"
    fi
  done
}

#main
#显示当前设备列表
echo "当前块设备列表:"
lsblk | awk '{printf "%s\t\t%s\n",$1,$4}'
read_dirname
read_mountdir
echo "n
p
1


wq
" | fdisk /dev/${devname} && mkfs -t ext4 /dev/${devname}1

uuid=` blkid /dev/${devname}1  | awk '{print $2}' | awk -F= '($1="UUID") {print $2}' | sed 's/\"//g'`
if  [ -n "$uuid" ]
then
echo -e "UUID=${uuid}\t${mountdir}\text4\tdefaults\t0\t2" >> /etc/fstab
mount -a
df -h
fi