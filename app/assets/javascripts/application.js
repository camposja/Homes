// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//#= require jquery
//= require jquery_ujs

//= require 'cable'
//= require 'homes'
//= require 'application'

jQuery(document).ready(function(){
  jQuery('.map').gmap3({
          center:[48.8620722, 2.352047],
          zoom:4
        })
        .marker([
          {position:[48.8620722, 2.352047]},
          {address:"86000 Poitiers, France"},
          {address:"66000 Perpignan, France", icon: "http://maps.google.com/mapfiles/marker_grey.png"}
        ])
});
