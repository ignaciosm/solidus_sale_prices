# class Spree::BrandsController < Spree::StoreController
# 	def onsale
# 	  @brand = Spree::Brand.find_by(slug: params[:id]).products.joins(:stock_items).where("count_on_hand > ? OR #{Spree::Variant.table_name}.track_inventory = ? OR backorderable = ?", 0, false, true).distinct
# 	end
# end

module SpreeSimpleSales
  module HomeControllerDecorator
    def onsale
      # @products = Spree::Product.joins(:sale_prices).where('spree_sale_prices.value is not null').where('enabled =?', true).where('(start_at <= ? OR start_at IS NULL) AND (end_at >= ? OR end_at IS NULL)', Time.now, Time.now).distinct
      # @instock_products = @products.joins(:stock_items).where("count_on_hand > ? OR #{Spree::Variant.table_name}.track_inventory = ? OR backorderable = ?", 0, false, true).distinct
      # @taxonomies = Spree::Taxonomy.includes(root: :children)

      @searcher = build_searcher(params.merge(include_images: true))
      @products = @searcher.retrieve_products_onsale
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end
  end
end

Spree::HomeController.prepend SpreeSimpleSales::HomeControllerDecorator