/*global providers_module */
/*global angular */
/*global console */


providers_module.controller('ProvidersController', ['$scope', '$filter', 'ProviderService', 'ServiceService', function ($scope, $filter, ProviderService, ServiceService) {

  "use strict";

  $scope.search = {};

  $scope.search.locations = "";
  $scope.search.states = "";
  $scope.search.sizes = [];
  $scope.search.number_of;
  
  $scope.search.sel_service = [];

  $scope.providers;
  
  $scope.mapOptions = {zoomControl: true, panControl: true, scaleControl: true};
  
  $scope.filteredProviders;
  
  ProviderService.get().$promise.then(function (providers) {
    $scope.providers = providers;
  });
  
  $scope.map = { zoom: 10, control: {}, markers: []};

  $scope.map.markers = [];

  $scope.search.price = {
    min: 0,
    max: 1000,
    ceil: 1000,
    floor: 0
  };
  
  $scope.onClick = function (marker, eventName, model) {
    model.show = !model.show;
  };
  
  
  $scope.$watch('filteredProviders', function () {
    
    
    var temp_markers, log;
    
    log = [];
    temp_markers = [];

    angular.forEach($scope.filteredProviders, function (provider, key) {
      
      console.log(provider.name);
      temp_markers.push({
        latitude: provider.latitude,
        longitude: provider.longitude,
        id: provider.id,
        icon: 'assets/huella-mensaje-17-mini.png',
        provider: {name: provider.name, avatar: provider.avatar}
      });
    }, log);

    $scope.map.markers = temp_markers;
     
    
  });

  $scope.onSliderChange = function () {
    $scope.search.price.min = $scope.priceSlider.min;
    $scope.search.price.max = $scope.priceSlider.max;
  };

  $scope.services = ServiceService.get();



}]);
