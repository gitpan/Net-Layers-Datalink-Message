package Net::Layers::Datalink::Message;

require 5.005_62;
use strict;
use warnings;
use Digest::MD5;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);
our $VERSION = '0.01';

# Technique for new class borrowed from Effective Perl Programming by Hall / Schwartz pp 211

sub new{
  my $pkg = shift;
  # bless package variables
  bless{
  message => "",
  message_id => 0,
  checksum => "",
  is_valid => 0,
  message_as_string => "",
  @_}, $pkg;
}

sub toString{
  my $self = shift;
  my $messageContents = sprintf("%08i-%s",$self->{message_id} , $self->{message});
  my $ctx = Digest::MD5->new;  # digest object for checksum
  $ctx->add($messageContents);
  $self->{checksum} = $ctx->hexdigest; 
  $self->{message} = $self->{checksum} . "-" . $messageContents;
  return($self->{message});
}

sub setMessageFromString{
  my $self = shift;
  my $recievedString = shift;
  if (defined $recievedString)
    {
      if ($recievedString =~ /^([0123456789abcdef]){32}-([0123456789]){8}-(.)*/)
        {
          my @ary = split (/-/,$recievedString,3);
          my $ctx = Digest::MD5->new;  # digest object for checksum
          $ctx->add($ary[1] . "-" . $ary[2]); # The message
          if ($ary[0] =~ $ctx->hexdigest)
            {
              $self->{message}=$ary[2];
              $self->{message_id}=$ary[1];
              return(1);
            }
          else
            {
              return(0);
            }
        }
    }
  return(0);
}

sub getMessage{
  my $self = shift;
  return($self->{message});
}

sub getMessageID{
  my $self = shift;
  return($self->{message_id});
}

1;

__END__

=head1 NAME

Net::Layers::Datalink::Message - Perl extension for packaging and unpackaging a message.

=head1 SYNOPSIS

  use Net::Layers::Datalink::Message;

  # packaging a message

  my $msg = Net::Layers::Datalink::Message->new(message=>"Hi Mom",message_id=>1);
  &send $msg->toString();  

  # unpackaging a message

  my $msg = Net::Layers::Datalink::Message->new();
  $isValid=$msg->setMessageFromString($recievedString);
  if ($isValid)
    {
      my $messageID = $msg->getMessageID();
      my $message = $msg->getMessage();
      print "MessageID: $messageID Message: $message()";
    }


=head1 DESCRIPTION

This module has two modes.  One is used for sending messages and the second mode is used for reciving messages.

The first mode is accepts a message and message id.  The function toString is next called. The function toString
prepends to a string an MD5 digest of the message and the message id, and returns the new string.

The second mode is called by using the setMessageFromString function as shown above.  The recieved string is
parsed.  The subroutine checks for a valid MD5 hash of the message and message id.  If everything is ok, the return
value of the setMessageFunction is one, otherwise it is zero.  The message and message id are available from seperate
functions.

=head1 DETAILS

=head2 $msg = Net::Layers::Datalink::Message->new();

Returns a new Datalink Message object.  (The new method is called this way only when a message has been recieved.)

=head2 $msg = Net::Layers::Datalink::Message->new(message=>"Hi Dad",message_id=>2);

Returns a new Datalink Message object with the message "Hi Dad", and a message_id of 2.  (This new method is only
called when a message is about to be sent.)  ****WARNING**** All message id's must not exceed 8 digits
eg: 12345678 is a valid message id while 123456789 is NOT.

The message header (md5 checksum && message id) takes up 42 bits.  (Coincidence I swear!)

=head2 &send $msg->toString();

The function toString returns the message, with a prepended MD5 digest of the orignal message and the message id.

=head2 $isValid=$msg->setMessageFromString($recievedString);

The function returns 1 or 0 if the string matches the form of the toString method above.  
The subroutine checks for a valid MD5 hash of the message and message id.

=head2 $msg->getMessage();

Returns the orignal message.

=head2 $msg->getMessageID();

Returns the orignal message ID.

=head1 AUTHOR

Zachary Zebrowski, zak@freeshell.org

=head1 SEE ALSO

Net::Layers::Datalink::ReliableMultiSend

Net::Layers::Physical::Unreliable

Effective Perl Programming by Joseph N. Hall with Randl L. Schwartz

Computer Networks by Andrew Anenbaum

=cut

