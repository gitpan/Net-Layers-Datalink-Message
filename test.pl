BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}
use Net::Layers::Datalink::Message;
$loaded = 1;
print "ok 1\n";

  # Message digest is known from previous testing.

  my $msg = Net::Layers::Datalink::Message->new(message=>"This is a test message",message_id=>1);
  if ($msg->toString() =~ /^7767cfe237c8eb5e6f768a95368d64f6-00000001-This is a test message$/)
    {
      print "ok 2\n";
    }
  else
    {
      print "NOT OK 2\n";
    }

  # construct valid message and test piece parts

  my $msg2 = Net::Layers::Datalink::Message->new();
  if ($msg2->setMessageFromString("7767cfe237c8eb5e6f768a95368d64f6-00000001-This is a test message"))
    {
      print "ok 3\n";
    }
  else
    {
      print "NOT OK 3\n";
    }

  if ($msg2->getMessage() =~/This is a test message/)
    {
      print "ok 4\n";
    }
  else 
    {
      print "NOT OK 4\n";
    }

  if ($msg2->getMessageID() =~/1/)
    {
      print "ok 5\n";
    }
  else
    {
      print "NOT OK 5\n";
    }

  # test invalid message

  my $msg3 = Net::Layers::Datalink::Message->new();
  if ($msg3->setMessageFromString("xxx"))
    {
      print "NOT OK 6";
    }
  else
    {
      print "ok 6\n";
    }

  # test no message

  my $msg4 = Net::Layers::Datalink::Message->new();
  if ($msg4->setMessageFromString())
    {
      print "NOT OK 7";
    }
  else
    {
      print "ok 7\n";
    }
