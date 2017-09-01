ActiveAdmin.register Institution do
  permit_params :name, :address, :city, :province, :number, :surface, :workers_count, :cuit,
                :activity, :institutions_count, :contract, :postal_code, :phone_number,
                :longitude, :latitude, :zone_id

  controller do
    def destroy
      destroy! do |_success, failure|
        failure.html do
          flash[:error] = 'La acción falló: ' + resource.errors.full_messages.to_sentence
          render action: :index
        end
      end
    end

    # In order to avoid N+1 Query problem
    def scoped_collection
      Institution.includes(:zone)
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :cuit
    column :city
    column :province
    column :zone
    actions
  end

  show do # |institution|
    attributes_table do
      row :name
      row :cuit
      row :address
      row :city
      row :province
      row :zone
      row :number
      row :surface
      row :workers_count
      row :activity
      row :institutions_count
      row :contract
      row :postal_code
      row :phone_number
      row :longitude
      row :latitude
    end
  end

  form do |f|
    f.inputs 'Institution Details', allow_destroy: true do
      f.semantic_errors(*f.object.errors.keys)
      f.input :name
      f.input :cuit
      f.input :address
      f.input :city
      f.input :province
      f.input :zone_id, as: :select, collection: Zone.all(&:name), include_blank: false
      f.input :number
      f.input :surface
      f.input :workers_count
      f.input :activity
      f.input :institutions_count
      f.input :contract
      f.input :postal_code
      f.input :phone_number
      f.input :latitude, as: :number, hint: '-34.44909'
      f.input :longitude, as: :number, hint: '-58.53176'
    end
    f.actions
  end
end
