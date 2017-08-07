param (
    [String] $ErrString
)

$letters = 'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ'.ToCharArray();

function _cvt() {
    param ( [Char] $n )
    if ($n -gt 191 -and $n -lt 256) {
        return $letters[$n - 192];
    } else {
        return $n;
    }
}

$i = 0;
while ($i -lt $ErrString.Length) {
    $c = $ErrString[$i];
    if ($c -eq '&' -or $c -eq '#') {
        $c = [Int32]::Parse($ErrString.Substring($i + 2, 3));
        $i += 5;
    }
    Write-Host -NoNewLine (_cvt($c));
    ++$i;
}    
Write-Host;
