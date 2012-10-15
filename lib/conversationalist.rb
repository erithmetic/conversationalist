require 'conversions'
require 'active_support/inflector'

require 'conversationalist/defaults'
require 'conversationalist/parser'
require 'conversationalist/tag'
require 'conversationalist/token'

module Conversationalist
  class << self
    attr_accessor :debug
  end
  
  self.debug = false
  
  class << self
    attr_accessor :si_units

    def parse(text)
      Parser.new(text).parse
    end

    def base(unit)
      group_name = @@groups.keys.find { |k| @@groups[k].include?(unit) }
      group = @@groups[group_name]
      si_units.find { |u| group.include?(u.to_sym) }
    end
  end

  self.si_units = [:metre, :metres, :meter, :meters, :litre, :litres, :liter, :liters, :joule, :joules, :gram, :grams, :watt, :watts]

  @@groups = {
    :area => [
      :square_meter, :square_metre, :square_kilometer, :square_kilometre,
      :acre, 
      :are,
      :barn,
      :circular_mil,
      :hectare,
      :square_foot,
      :square_inch,
      :square_mile,
      :square_yard
    ],
    :distance => [
      :meter, :metre, :m, :kilometer, :kilometre,
      :inch,
      :mil,
      :foot,
      :yard,
      :mile, :miles,
      :nautical_mile,
    ],
    :energy => [
      :joule, :J, :kilogoule, :kJ, :megajoule, :mJ, :gigajoule, :GJ,
      :watt_hour, :wh, :kilowatt_hour, :kWh, :megawatt_hour, :MWh,
      :therm,
      :us_therm,
      :kilocalorie,
      :calorie,
      :mean_kilocalorie,
      :mean_calorie,
      :it_kilocalorie,
      :it_calorie,
      :foot_poundal,
      :foot_pound_force,
      :erg,
      :british_thermal_unit,
      :mean_british_thermal_unit,
      :it_british_thermal_unit,
    ],
    :mass => [
      :gram, :g, :kilogram, :kg,
      :ounce,
      :pound,
      :assay_ton,
      :metric_ton,
      :ton,
    ],
    :power => [
      :watt, :w, :kilowatt, :kW, :megawatt, :MW, :gigawatt, :GW,
      :british_thermal_unit_per_hour,
      :it_british_thermal_unit_per_hour,
      :british_thermal_unit_per_second,
      :it_british_thermal_unit_per_second,
      :calorie_per_minute,
      :calorie_per_second,
      :erg_per_second,
      :foot_pound_force_per_hour,
      :foot_pound_force_per_minute,
      :foot_pound_force_per_second,
      :horsepower,
      :boiler_horsepower,
      :electric_horsepower,
      :metric_horsepower,
      :uk_horsepower,
      :water_horsepower,
      :kilocalorie_per_minute,
      :kilocalorie_per_second,
      :ton_of_refrigeration, :tons_of_refrigeration => 3.516853e+3
    ],
    :temperature => [
      :kelvin, :K,
      :celsius, :C,
      :degree_celsius,
      :degrees_celsius,
      :fahrenheit, :F,
      :degree_fahrenheit,
      :degrees_fahrenheit,
      :rankine, :rankines
    ], 
    :time => [
      :second,
      :minute,
      :hour,
      :day,
      :year,
    ],
    :volume => [
      :litre,
      :barrel,
      :bushel,
      :cubic_meter, :cubic_metre,
      :cup,
      :imperial_fluid_ounce,
      :ounce,
      :imperial_gallon,
      :gallon,
      :imperial_gill,
      :gill,
      :pint,
      :liquid_pint,
      :quart,
      :liquid_quart,
      :tablespoon,
      :teaspoon,
    ]
  }

  @@groups.each do |group, units|
    plural_units = units.map(&:to_s).map(&:pluralize).map(&:to_sym)
    @@groups[group] += plural_units
  end
  
  # collect up all the possible unit types that Alchemist can handle
  POSSIBLE_UNITS = @@groups.values.flatten
  MULTIWORD_UNITS = POSSIBLE_UNITS.collect{|u| u.to_s}.grep(/_/)
end
