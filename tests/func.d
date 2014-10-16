module tests.func;

import std.stdio;
import unit_threaded;
import dejector;

import tests.utils;
import tests.cut;

@UnitTest
void get_delegate_should_produce_delegateOfService() {
   auto dejector = new Dejector;
   dejector.bind!(IService, Service);

   auto func = dejector.getDelegate!IService;
   func.instanceof!(IService delegate()).shouldBeTrue;
   func().instanceof!(IService).shouldBeTrue;
}
//public void Resolving_as_Func_should_throw_for_not_registered_service()
@UnitTest
void func_itself_is_transient() {
   auto dejector = new Dejector;
   dejector.bind!(IService, Service);
   auto one = dejector.get!IService;
   auto another = dejector.get!IService;
   one.shouldNotEqual(another);
}
@UnitTest
void given_registered_transient_Resolved_Func_should_create_new_instances() {
   auto dejector = new Dejector;
   dejector.bind!(IService, Service);
   auto func = dejector.getDelegate!IService;

   auto one = func();
   one.shouldNotBeNull;
   auto another = func();
   another.shouldNotBeNull;
   one.shouldNotEqual(another);
}

@UnitTest
void Given_registered_singleton_Resolved_Func_should_create_same_instances() {
   auto dejector = new Dejector;
   dejector.bind!(IService, Service, Singleton);
   auto func = dejector.getDelegate!IService;

   auto one = func();
   auto another = func();
   one.shouldEqual(another);
}
