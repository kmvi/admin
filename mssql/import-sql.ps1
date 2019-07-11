$server = '...'
$user = 'sa'
$password = '...'
$schema = 'dbo'
$db = '...'
$outdir = "d:\backup"

Get-ChildItem $outdir -Filter "*.dat" |
foreach-object {
    $table = $_.Name -replace '\.dat', ''

    $constr = "Persist Security Info=False;User ID=$user;Initial Catalog=$db;Data Source=$server;Password=$password"
    $con = New-Object System.Data.SqlClient.SqlConnection($constr)
    try {
        $con.Open();
        $cmd = $con.CreateCommand()
        try {
            $cmd.CommandText = "truncate table [$table]"
            $reader = $cmd.ExecuteNonQuery();
        } finally {
            if ($null -ne $cmd) {
                $cmd.Dispose();
            }
        }
    } finally {
        if ($null -ne $con) {
            $con.Dispose()
        }
    }

    bcp "$db.$schema.[$table]" in $outdir\$table.dat -S $server -U $user -P $password -n -k
}
