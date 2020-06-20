#sftpman setup --id=silicom --host=10.100.1.42 --port=22 --user=cbs --mount_opt="compression=yes" --mount_opt="follow_symlinks" --mount_opt="workaround=rename" --mount_opt="reconnect" --mount_opt="no_readahead" --mount_opt="sshfs_sync" --mount_opt="sync_readdir" --mount_point=/home/cbs/ --auth_method=publickey --ssh_key=/home/chrbirks/.ssh/id_rsa.pub

#sftpman setup --id=silicom --host=10.100.1.42 --port=22 --user=cbs --mount_opt="compression=yes" --mount_opt="follow_symlinks" --mount_opt="workaround=rename" --mount_point=/home/cbs/ --auth_method=publickey --ssh_key=/home/chrbirks/.ssh/id_rsa.pub
sftpman setup --id=silicom --host=10.100.1.42 --port=22 --user=cbs --mount_opt="compression=no" --mount_opt="follow_symlinks" --mount_opt="workaround=rename" --mount_point=/home/cbs/ --auth_method=publickey --ssh_key=/home/chrbirks/.ssh/id_rsa.pub
sftpman setup --id=silicomstorage --host=10.100.1.42 --port=22 --user=cbs --mount_opt="compression=no" --mount_opt="follow_symlinks" --mount_opt="workaround=rename" --mount_point=/mnt/storage/ --auth_method=publickey --ssh_key=/home/chrbirks/.ssh/id_rsa.pub

sftpman mount silicom
sftpman mount silicomstorage
