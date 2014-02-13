# do not forget to set 'GatewayPorts yes' in sshd config

$ssh = "plink.exe"
$hostname = "hostname"
$port = 22
$user = "root"
$password = "password"
$forwarded_port = 3389
$remote_port = 19999
$start_file = "rdp.txt"
$stop_file = "stop.txt"
$mon_path = "d:\btsync"

while (1) {
	$start_path = join-path $mon_path $start_file
	$stop_path = join-path $mon_path $stop_file
	
	if ([System.IO.File]::Exists($start_path)) {
		write "Found file $start_file, starting process..."
		$cmd = [String]::Format("-P {1} -R *:{2}:localhost:{3} {4}@{5} -pw {6} -N",
			$ssh, $port, $remote_port, $forwarded_port, $user, $hostname, $password)

		# just in case, kill the process if exists
		taskkill /im plink.exe /f
		start-process $ssh $cmd
		del $start_path
	} elseif ([System.IO.File]::Exists($stop_path)) {
		write "Found file $stop_file, stopping process..."
		taskkill /im plink.exe /f
		del $stop_path
	}

	[System.Threading.Thread]::Sleep(60000)
}



