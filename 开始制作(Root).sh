#By 酷安@Adou2056 & Thanks to grrandou
#Project at Github:http://github.com/Adou2056/make_root_boot
#!/bin/sh
#挂载根目录为可读写
su -c "mount -o rw,remount /"
#复制abootimg到/system/bin
su -c "cp ./abootimg /system/bin"
#设置abootimg工具755权限
su -c "chmod 755 /system/bin/abootimg"

echo "    ＊═—═—═—═—═—═—＊*＊═—═—═—═—═—═—＊    "
echo "


               少女祈祷中...     


"
echo "    ＊═—═—═—═—═—═—＊*＊═—═—═—═—═—═—＊    "
initrd_number=$(cd ./initrd && ls -l | grep "^-" | wc -l)
abootimg -x ./rootedboot/*.img
if [ "$?" -eq "0" ]
then
    echo "


   ＊ 拆解rootedboot目录中的boot生成ramdisk(./initrd.img)


    "
    #移动initrd.img到initrd文件夹
    mv ./initrd.img ./initrd/initrd.img
    echo "
    
   ＊ ramdisk复制到initrd文件夹(/initrd/initrd.img)
    
    
    "
elif [ -e ./initrd/initrd.img ]
then
    echo "
    
    
   ＊ 已检测到initrd.img，继续制作中......
    
    
    "
else
    echo "

   
   ＊ 无法寻找到abootimg或者unrootedboot...
   ＊ 执行失败 请检查root权限
   ＊ 确保unrootedboot放在unrootedboot目录!

    "
    exit
fi

while true
do
abootimg -u ./unrootedboot/*.img -r ./initrd/initrd.img
if [ "$?" -eq "0" ]
then
    echo "


   ＊ ramdisk写进>>>unrootedboot


    " 
    #导出new_rootedboot
    cp ./unrootedboot/*.img ./new_rootedboot
    
    echo "
.·°∴ ☆.·°∴ ☆·°.·°∴ ☆·°.·°∴ ☆·°.·°∴ ☆
          
       已制作完毕新rootedboot
  该文件存在于new_rootedboot文件夹
    
.·°∴ ☆.·°∴ ☆·°.·°∴ ☆·°.·°∴ ☆·°.·°∴ ☆
    "
    rm -rf ./unrootedboot/*.img
    unrooted_number=$(cd ./unrootedboot && ls -l | grep "^-" | wc -l)
    if [ "$unrooted_number" -eq "0" ]; then
    echo "
    好像成功惹？刷入试试吧awa
    "
    break
    fi
else
    echo "


   ＊ 请检查initrd名称+后缀是否为 initrd.img !
   ＊ 请检查unrootedboot文件夹是否有boot文件 !


    "
    exit
fi
done
#删除abootimg工具
su -c "rm -rf /system/bin/abootimg"
#挂载根目录为只读
su -c "mount -o ro,remount /"
echo "
    Fin
    "