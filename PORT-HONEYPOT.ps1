#This script will run in the background and notify an email address if a connection is received on the port specified. 

#Change $toemail to the email address you want to notify
#Change $SmtpServer to a SMTP relay that does not require authentication
#Change $port to the port you want to monitor
 
 #$wshell = New-Object -ComObject Wscript.Shell
 
    [int]$port=3389
    $toemail="test@test.com" #change this
    $SmtpServer="test.com" #change this
    $endpoint = new-object System.Net.IPEndPoint ([system.net.ipaddress]::any, $port)
    $listener = new-object System.Net.Sockets.TcpListener $endpoint
    $listener.start()
    write-host "Waiting for a connection on port $port..."
    do {
        $client = $listener.AcceptTcpClient() # will block here until connection
        $stream = $client.GetStream();
        #write-host "Connected from $($client.Client.RemoteEndPoint)"
        Send-MailMessage -From "connect-alert@bi.com" -to $toemail -Subject "Connect Alert" -SmtpServer $SmtpServer -body "Connected from $($client.Client.RemoteEndPoint)"
        $stream.Dispose()
        #$client.Dispose()
    } while ($line -ne ([char]4))
    $listener.stop()
