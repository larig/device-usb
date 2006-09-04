#!perl -T

use Test::More qw(no_plan);
use Device::USB;

#
# No plan, because the number of tests depends on the number of
#  busses and devices on the system.
#

my $usb = Device::USB->new();
ok( defined $usb, "Object successfully created" );

my $busses = $usb->list_busses();
ok( defined $busses, "USB busses found" );

can_ok( "Device::USB::Device",
        qw/filename config bcdUSB bDeviceClass bDeviceSubClass
	   bDeviceProtocol bMaxPacketSize0 idVendor idProduct
	   bcdDevice iManufacturer iProduct iSerialNumber bNumConfigurations/ );

foreach my $bus (@{$busses})
{
    foreach my $dev (@{$bus->devices()})
    {
        isa_ok( $dev, "Device::USB::Device" );
	my $filename = $dev->filename();
        like( $filename, qr/^\d+$/, "Filename is a digit string" );
	my $configs = $dev->config();
	isa_ok( $configs, 'ARRAY' );
	like( $dev->bcdUSB(), qr/^\d+\.\d\d$/, "$filename: USB Version" );
	like( $dev->bDeviceClass(), qr/^\d+$/, "$filename: device class" );
	like( $dev->bDeviceSubClass(), qr/^\d+$/, "$filename: device subclass" );
	like( $dev->bMaxPacketSize0(), qr/^\d+$/, "$filename: max packet size" );
	like( $dev->idVendor(), qr/^\d+$/, "$filename: vendor id" );
	like( $dev->idProduct(), qr/^\d+$/, "$filename: product id" );
	like( $dev->bcdDevice(), qr/^\d+\.\d\d$/, "$filename: Device version" );
	like( $dev->iManufacturer(), qr/^\d+$/, "$filename: manufacturer index" );
	like( $dev->iProduct(), qr/^\d+$/, "$filename: product index" );
	like( $dev->iSerialNumber(), qr/^\d+$/, "$filename: serial number index" );
	is( $dev->bNumConfigurations(), scalar(@{$configs}),
	    "$filename: number of configurations matches" );
    }
}
