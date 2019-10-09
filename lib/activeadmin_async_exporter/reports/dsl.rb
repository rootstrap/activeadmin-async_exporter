# frozen_string_literal: true

module ActiveadminAsyncExporter
  module Reports
    module DSL
      def csv_report(columns:, decorate_model: false)
        action_item :download_csv, only: :index do
          link_to 'Download CSV',
            { action: :download_csv, params: params },
            { method: :post, data: { confirm: 'Are you sure you want to generate this report?' } }
        end

        collection_action :download_csv, method: :post do
          options = {
            controller: self.class.to_s,
            columns: columns,
            decorate_model: decorate_model,
            query: params['q']
          }
          ActiveadminAsyncExporter::Worker.perform_async(options)
          redirect_to(action: :index)
        end
      end
    end
  end
end
