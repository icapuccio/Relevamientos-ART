ActiveAdmin.register User do
  permit_params :email, :name, :last_name, :role, :address, :latitude, :longitude, :zone_id

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
      User.includes(:zone)
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :last_name
    column :role
    column :zone
    actions
  end

  show do # |user|
    attributes_table do
      row :email
      row :name
      row :last_name
      row :role
      row :address
      row :latitude
      row :longitude
      row :zone
    end
  end

  form do |f|
    f.inputs 'User Details', allow_destroy: true do
      f.semantic_errors(*f.object.errors.keys)
      f.input :email, input_html: { readonly: true }, as: :string unless f.object.new_record?
      f.input :email, as: :string if f.object.new_record?
      f.input :name
      f.input :last_name
      f.input :role, as: :select, collection: User.roles.keys, include_blank: false
      f.input :address
      f.input :latitude, as: :number, input_html: { readonly: true }
      f.input :longitude, as: :number, input_html: { readonly: true }
      f.input :zone_id, as: :select, collection: Zone.all(&:name), include_blank: true
    end
    f.actions
  end
end
