Import-Module "$PSScriptRoot\WinTweaker.psd1" -Force

InModuleScope 'WinTweaker' {
    describe 'Get-CallingFunctionName' {
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

    describe 'Start-Tweak' {

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

    describe 'Set-RegistryValue' {

        #region Mocks
        mock 'Set-ItemProperty'
        #endregion

        context 'Local computer execution' {
            $params = @{
                KeyPath = 'HKLM:\Software'
                Name    = 'keyname'
                Value   = 'keyvalue'
            }
            Set-RegistryValue @params

            it 'calls Set-ItemProperty with the expected parameters' {
                
                $assMParams = @{
                    CommandName     = 'Set-ItemProperty'
                    Times           = 1
                    Exactly         = $true
                    ExclusiveFilter = {
                        $PSBoundParameters.Path -eq 'HKLM:\Software' -and
                        $PSBoundParameters.Name -eq 'keyname' -and
                        $PSBoundParameters.Value -eq 'keyvalue'
                    }
                }
                Assert-MockCalled @assMParams
            }
        }
    }

    describe 'Remove-RegistryValue' {

        #region Mocks
        mock 'Remove-ItemProperty'
        #endregion

        context 'Local computer execution' {
            $params = @{
                KeyPath = 'HKLM:\Software'
                Name    = 'keyname'
            }
            Remove-RegistryValue @params

            it 'calls Remove-ItemProperty with the expected parameters' {
                
                $assMParams = @{
                    CommandName     = 'Remove-ItemProperty'
                    Times           = 1
                    Exactly         = $true
                    ExclusiveFilter = {
                        $PSBoundParameters.Path -eq 'HKLM:\Software' -and
                        $PSBoundParameters.Name -eq 'keyname'
                    }
                }
                Assert-MockCalled @assMParams
            }
        }
    }
}