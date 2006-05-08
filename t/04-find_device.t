#!perl -T

use Test::More tests => 8;
use Device::USB;

my $usb = Device::USB->new();

ok( defined $usb, "Object successfully created" );
can_ok( $usb, "find_device" );

ok( !defined $usb->find_device( 0xFFFF, 0xFFFF ), "No device found" );

my $busses = $usb->list_busses();
ok( defined $busses, "USB busses found" );

my $found_device = find_an_installed_device( 0, @{$busses} );

SKIP:
{
    skip "No USB devices installed", 4 unless defined $found_device;

    my $vendor = $found_device->idVendor();
    my $product = $found_device->idProduct();

    my $dev = $usb->find_device( $vendor, $product );

    ok( defined $dev, "Device found." );
    is_deeply( $dev, $found_device, "first device matches" );

    $found_device = find_an_installed_device( 1, @{$busses} );
    skip "Only one USB device installed", 2 unless $found_device;
    $vendor = $found_device->idVendor();
    $product = $found_device->idProduct();

    $dev = $usb->find_device( $vendor, $product );

    ok( defined $dev, "Device found." );
    is_deeply( $dev, $found_device, "second device matches" );
}


sub find_an_installed_device
{
    my $which = shift;
    foreach my $bus (@_)
    {
        next unless @{$bus->devices()};
	return $bus->devices()->[0] unless $which--;
    }

    return;
}