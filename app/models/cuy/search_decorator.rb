# frozen_string_literal: true

require 'spree/deprecation'

module Spree
  module Core
    module Search
      class Base
        attr_accessor :properties
        attr_accessor :current_user
        attr_accessor :pricing_options

        def retrieve_products
          @products = get_base_scope
          curr_page = @properties[:page] || 1

          unless Spree::Config.show_products_without_price
            #@products = @products.joins(:prices).merge(Spree::Price.where(pricing_options.search_arguments)).distinct    >>>>CAMBIADO POR IGNACIO
            @products = @products.joins(:stock_items).where("count_on_hand > ? OR #{Spree::Variant.table_name}.track_inventory = ? OR backorderable = ?", 0, false, true).distinct
          end
          @products = @products.page(curr_page).per(@properties[:per_page])
        end

      end
    end
  end
end