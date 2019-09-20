Import-Module "$PSScriptRoot\WinTweaker.psd1" -Force

InModuleScope 'WinTweaker' {
    describe 'Get-CallingFunctionName' -Tag 'PrivateFunction' {
        #region Mocks
        ## This is better but I'm too lazy to figure out how to populate property values to check
        # $callStack = 0..1 | foreach { New-MockObject -Type 'System.Management.Automation.CallStackFrame' }
        $callStack = Get-PsCallStack
        #endregion

        $result = Get-CallingFunctionName -CallStack $callStack
    
        it 'returns the second element in the callstack array' {
            $result | should -Be 'DescribeImpl'
        }

    }

    describe 'Start-Tweak' -Tag 'PrivateFunction' {

        #region Mocks
        mock 'Get-CallingFunctionName' { 'callingfunctionname' }
        mock 'Invoke-Command'
        #endregion

        context 'Local computer execution' {
            
            context 'No Credential' {
                $params = @{
                    Code = { foo }
                }
                Start-Tweak @params

                it 'calls Invoke-Command with the expected parameters' {
                
                    $assMParams = @{
                        CommandName     = 'Invoke-Command'
                        Times           = 1
                        Exactly         = $true
                        ExclusiveFilter = {
                            $PSBoundParameters.ComputerName -eq $env:COMPUTERNAME -and
                            $PSBoundParameters.AsJob -eq $true -and
                            $PSBoundParameters.ScriptBlock.ToString() -eq ' foo '
                        }
                    }
                    Assert-MockCalled @assMParams
                }
            }

            context 'With Credential' {

                $password = ConvertTo-SecureString 'MySecretPassword' -AsPlainText -Force
                $credential = New-Object System.Management.Automation.PSCredential ('root', $password)

                $params = @{
                    Code         = { foo }
                    ComputerName = 'REMOTE'
                    Credential   = $credential
                }
                Start-Tweak @params

                it 'calls Invoke-Command with the expected parameters' {
                    
                    $assMParams = @{
                        CommandName     = 'Invoke-Command'
                        Times           = 1
                        Exactly         = $true
                        ExclusiveFilter = {
                            $PSBoundParameters.ComputerName -eq 'REMOTE' -and
                            $PSBoundParameters.AsJob -eq $true -and
                            $PSBoundParameters.Credential.UserName -eq 'root' -and
                            $PSBoundParameters.ScriptBlock.ToString() -eq ' foo '
                        }
                    }
                    Assert-MockCalled @assMParams
                }
            }

            context 'Asynchronous' {

                $params = @{
                    Code         = { foo }
                    Asynchronous = $true
                }
                Start-Tweak @params

                it 'calls Invoke-Command with the expected parameters' {
                
                    $assMParams = @{
                        CommandName     = 'Invoke-Command'
                        Times           = 1
                        Exactly         = $true
                        ExclusiveFilter = {
                            $PSBoundParameters.ComputerName -eq $env:COMPUTERNAME -and
                            'AsJob' -notin $PSBoundParameters.Keys -and
                            $PSBoundParameters.ScriptBlock.ToString() -eq ' foo '
                        }
                    }

                    Assert-MockCalled @assMParams
                }
            }

            context 'With args' {

                $params = @{
                    Code      = { foo }
                    Arguments = @('arg1', 'arg2')
                }
                Start-Tweak @params

                it 'calls Invoke-Command with the expected parameters' {
                
                    $assMParams = @{
                        CommandName     = 'Invoke-Command'
                        Times           = 1
                        Exactly         = $true
                        ExclusiveFilter = {
                            $PSBoundParameters.ComputerName -eq $env:COMPUTERNAME -and
                            $PSBoundParameters.ScriptBlock.ToString() -eq ' foo ' -and
                            (-not (diff $PSBoundParameters.ArgumentList @('arg1', 'arg2')))
                        }
                    }

                    Assert-MockCalled @assMParams
                }
            }
        }

        context 'Remote computer execution' {

            context 'No Credential' {
                $params = @{
                    Code         = { foo }
                    ComputerName = 'REMOTE'
                }
                Start-Tweak @params

                it 'calls Invoke-Command with the expected parameters' {
                
                    $assMParams = @{
                        CommandName     = 'Invoke-Command'
                        Times           = 1
                        Exactly         = $true
                        ExclusiveFilter = {
                            $PSBoundParameters.ComputerName -eq 'REMOTE' -and
                            $PSBoundParameters.AsJob -eq $true -and
                            $PSBoundParameters.ScriptBlock.ToString() -eq ' foo '
                        }
                    }
                    Assert-MockCalled @assMParams
                }
            }

            context 'With Credential' {
                $password = ConvertTo-SecureString 'MySecretPassword' -AsPlainText -Force
                $credential = New-Object System.Management.Automation.PSCredential ('root', $password)

                $params = @{
                    Code         = { foo }
                    ComputerName = 'REMOTE'
                    Credential   = $credential
                }
                Start-Tweak @params

                it 'calls Invoke-Command with the expected parameters' {
                
                    $assMParams = @{
                        CommandName     = 'Invoke-Command'
                        Times           = 1
                        Exactly         = $true
                        ExclusiveFilter = {
                            $PSBoundParameters.ComputerName -eq 'REMOTE' -and
                            $PSBoundParameters.AsJob -eq $true -and
                            $PSBoundParameters.Credential.UserName -eq 'root' -and
                            $PSBoundParameters.ScriptBlock.ToString() -eq ' foo '
                        }
                    }
                    Assert-MockCalled @assMParams
                }
            }
        }
    }

    describe 'Enable-ShutdownTracker' -Tag 'Tweak' {
        #region Mocks
        mock 'Start-Tweak'        
        #endregion

        context 'Local computer' {

            $result = Enable-ShutdownTracker

            it 'calls Start-Tweak' {

                $assMParams = @{
                    CommandName = 'Start-Tweak'
                    Times       = 1
                    Exactly     = $true
                }
                Assert-MockCalled @assMParams

            }
        }

        context 'Remote computer' {
            context 'alternate credential' {

                $password = ConvertTo-SecureString 'MySecretPassword' -AsPlainText -Force
                $credential = New-Object System.Management.Automation.PSCredential ('root', $password)

                $result = Enable-ShutdownTracker -ComputerName 'X' -Credential $credential

                it 'calls Start-Tweak' {

                    $assMParams = @{
                        CommandName = 'Start-Tweak'
                        Times       = 1
                        Exactly     = $true
                    }
                    Assert-MockCalled @assMParams

                }
            }

            context 'no alternate credential' {

                $result = Enable-ShutdownTracker -ComputerName 'X'

                it 'calls Start-Tweak' {

                    $assMParams = @{
                        CommandName = 'Start-Tweak'
                        Times       = 1
                        Exactly     = $true
                    }
                    Assert-MockCalled @assMParams

                }

            }
        }
    }
}