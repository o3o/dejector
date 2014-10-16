//          Copyright Author 2014.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module tests.cut;

interface IDependency { }
class Dependency : IDependency { }
interface IService { }
class Service: IService { }
class ServiceA: IService { }
class ServiceB: IService { }
class AnotherService : IService { }
class ServiceWithDependency : IService {
   private IDependency _dependency;
   @property IDependency dependency() { return _dependency; }
   this(IDependency dependency) {
      _dependency = dependency;
   }
}

class AnotherServiceWithDependency : IService {
   private IDependency _dependency;
   @property IDependency dependency() { return _dependency; }
   this(IDependency dependency) {
      _dependency = dependency;
   }
}

