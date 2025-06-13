function Get-PermsAndForwarding {
    [CmdletBinding()]
    param
    (
        [String]
        [Parameter( Mandatory = $true, ValueFromPipeline = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
        $MailAddress,

        [switch]
        [Parameter( Mandatory = $false, ValueFromPipeline = $true, Position = 2, HelpMessage = "export as csv")]
        $CSV
    )

    # get mailbox
    $mailbox = Get-Mailbox -Identity $MailAddress

    # permissions
    Get-MailboxPermission -Identity $mailbox.Identity

    #forwarding
    $mailbox.ForwardingSmtpAddress
    $mailbox.ForwardingAddress
    $mailbox.DeliverToMailboxAndForward
}

export-modulemember -function Get-PermsAndForwarding