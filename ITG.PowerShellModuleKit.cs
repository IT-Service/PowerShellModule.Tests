// Custom Attribute for determining the order a test should run in, and also
// if the test will run in a container.
//
// It is used to decorate a .Tests.ps1 PowerShell script file that contains
// either unit tests or integration tests for a PowerShell module.
//
// The following are examples of how to write the decoration in a .Tests.ps1 file.
//
// # Integration test using container and specific order.
// [ITG.PowerShellModuleKit.IntegrationTest(OrderNumber = 1, ContainerName = 'ContainerName', ContainerImage = 'Organization/ImageName:Tag')]
// param()
//
// # Unit test using container.
// [ITG.PowerShellModuleKit.UnitTest(ContainerName = 'ContainerName', ContainerImage = 'Organization/ImageName:Tag')]
// param()

using System;

namespace ITG.PowerShellModuleKit
{
    // See the attribute guidelines at http://go.microsoft.com/fwlink/?LinkId=85236
    [System.AttributeUsage(System.AttributeTargets.All, Inherited = false, AllowMultiple = true)]
    public class Test : System.Attribute
    {
        public Test() {}

        public string ContainerName { get; set; }
        public string ContainerImage { get; set; }
    }

    public sealed class IntegrationTest : Test
    {
        public IntegrationTest() {}

        public int OrderNumber { get; set; }
    }

    public sealed class UnitTest : Test
    {
        public UnitTest() {}
    }
}
