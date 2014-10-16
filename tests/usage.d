module tests.usage;

import std.stdio;
import unit_threaded;
import dejector;
import core.exception;
class User {
   string name;
   this(string name) {
      this.name = name;
   }
}

interface IGreeter {
   string greet();
}

class Greeter: IGreeter {
   string greet() { return "Hello"; }
}

class GreeterWithName: IGreeter {
   private User user;
   this(User x) {
      user = x;
   }
   string greet() { return "Hello " ~ user.name; }
}

class GreeterWithMsg: IGreeter {
   private string _msg;
   this(string msg) {
      _msg = msg;
   }
   string greet() { return _msg ~ "!"; }
}


@UnitTest
void bind_with_function() {
   Dejector dejector = new Dejector;
   // doesn't work
   //dejector.bind!(IGreeter, Singleton)(() => new Greeter());

   dejector.bind!(IGreeter, Singleton)(function () => new Greeter());
   auto service = dejector.get!IGreeter;
   service.shouldNotBeNull;
   service.greet.shouldEqual("Hello");
}

@UnitTest
void bind_with_delegate() {
   Dejector dejector = new Dejector;
   dejector.bind!(IGreeter, Singleton)(delegate() { return new Greeter(); } );
   auto service = dejector.get!IGreeter;
   service.shouldNotBeNull;
   service.greet.shouldEqual("Hello");
}

@UnitTest
void bind_with_FunctionProvider() {
   Dejector dejector = new Dejector;
   auto p = new FunctionProvider( () => new Greeter());
   dejector.bind!(IGreeter, Singleton)(p);

   auto service = dejector.get!IGreeter;
   service.shouldNotBeNull;
   service.greet.shouldEqual("Hello");
}

import std.functional : toDelegate;
@UnitTest
void bind_with_toDelegate() {
   Dejector dejector = new Dejector;
   dejector.bind!(IGreeter, Singleton)(toDelegate( () => new Greeter()  ));

   auto service = dejector.get!IGreeter;
   service.shouldNotBeNull;
   service.greet.shouldEqual("Hello");
}

@UnitTest
void bind_with_InstanceProvider() {
   Dejector dejector = new Dejector;
   auto p = new InstanceProvider(new Greeter());
   dejector.bind!(IGreeter, Singleton)(p);

   auto service = dejector.get!IGreeter;
   service.shouldNotBeNull;
   service.greet.shouldEqual("Hello");
}
@UnitTest
void given_service_with_ctor_Bind_with_InstanceProvider_should_work() {
   Dejector dejector = new Dejector;
   auto p = new InstanceProvider(new GreeterWithMsg("a"));
   dejector.bind!(IGreeter, Singleton)(p);

   auto service = dejector.get!IGreeter;
   service.shouldNotBeNull;
   service.greet.shouldEqual("a!");
}

