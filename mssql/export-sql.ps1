$server = '...'
$user = 'sa'
$password = '...'
$schema = 'dbo'
$db = '...'
$outdir = "d:\backup"

$query = "select t.TABLE_NAME
from INFORMATION_SCHEMA.TABLES as t
where t.TABLE_SCHEMA = '$schema' and t.TABLE_TYPE = 'BASE TABLE'
order by t.TABLE_NAME"

$tables = New-Object System.Collections.Generic.List[System.String]

$constr = "Persist Security Info=False;User ID=$user;Initial Catalog=$db;Data Source=$server;Password=$password"
$con = New-Object System.Data.SqlClient.SqlConnection($constr)
try {
    $con.Open();
    $cmd = $con.CreateCommand()
    try {
        $cmd.CommandText = $query
        $reader = $cmd.ExecuteReader();
        try {
            while ($reader.Read()) {            
                $tables.Add($reader.GetString(0))
            }
        } finally {
            if ($null -ne $reader) {
                $reader.Dispose()
            }
        }
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

rmdir $outdir -Force | out-null
mkdir $outdir | out-null

foreach ($table in $tables) {
    bcp "$db.$schema.[$table]" out $outdir\$table.dat -S $server -U $user -P $password -n -k -V80
}
