
#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

data=`date "+%Y-%m-%d"`
backup_dir="/media/user/Data/backup-server"
mount_dir="/root/server"



backup_www-data () {
    echo "Архивируем каталоги сайтов!"

    mkdir -p $backup_dir/www/$data
    find $mount_dir -mindepth 1 -maxdepth 1 -type d -print|(
	while read line; do
	    dirf=`basename $line`
	    echo $line
	    echo " - Архивация каталога сайта: $dirf "
	    7za a -m0=lzma2 -mx=9 -mfb=64 -ms=on $backup_dir/www/$data/$dirf-backup.7z $line >> $backup_dir/www/$data/$data.log
	done
    )
}




echo "Монтируем удаленный каталог"
sshfs root@8.8.8.8:/var/www/user/data/www $mount_dir -o reconnect 
backup_www-data
echo "Отмонтируем удаленный каталог"
umount $mount_dir
