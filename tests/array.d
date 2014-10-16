module tests.array;

import std.stdio;
import unit_threaded;
import dejector;
import core.exception;
import tests.cut;

@UnitTest
void resolving_array_with_default_and_one_named_service_will_return_both_services() {
   Dejector container = new Dejector;
   container.bind!(IService, Service)();
   container.bind!(IService, AnotherService)("another");
   auto services = container.get!(IService[])();
   //services.length.shouldEqual(2);
}

@UnitTest
void i_can_resolve_array_of_singletons() {
   Dejector container = new Dejector;
   container.bind!(IService, ServiceA)();
   auto services = container.get!(IService[])();
   services.length.shouldEqual(1);
}
