# frozen_string_literal: true

module ActiveadminAsyncExporter
  class Worker
    include Sidekiq::Worker

    def perform(options = {})
      controller = options['controller'].classify.constantize.new
      columns = options['columns']

      file_path = Rails.root.join('tmp', filename(controller))

      CSV.open(file_path, 'wb', headers: true) do |csv|
        build_csv(csv, columns, controller, options)
      end

      upload_report(file_path)
    end

    private

    def collection(controller, options)
      controller.scoped_collection.ransack(options['query']).result
    end

    def filename(controller)
      [controller.scoped_collection.name.pluralize.downcase, Time.current.to_i].join('_') + '.csv'
    end

    def build_csv(csv, columns, controller, options)
      headers = columns.keys
      evaluators = columns.values

      csv << headers.map(&:to_s)

      collection(controller, options).find_in_batches do |group|
        group.each do |m|
          m = m.decorate if options['decorate_model']

          csv << evaluators.collect { |ev| m.send(ev) }
        end
      end
    end

    def upload_report(file_path)
      return unless ActiveadminAsyncExporter.configuration.upload_reports?

      ActiveadminAsyncExporter.configuration.report_uploader.upload(file_path)
    end
  end
end
