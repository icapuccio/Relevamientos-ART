ActiveAdmin.register User do
  permit_params :email, :name, :last_name, :role, :latitude, :longitude # , :zone_id

  controller do
    def destroy
      destroy! do |_success, failure|
        failure.html do
          flash[:error] = 'La acción falló: ' + resource.errors.full_messages.to_sentence
          render action: :index
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :last_name
    column :role
    actions
  end

  show do # |user|
    attributes_table do
      row :email
      row :name
      row :last_name
      row :role
      row :latitude
      row :longitude
    end
  end

  form do |f|
    f.inputs 'User Details', allow_destroy: true do
      f.semantic_errors(*f.object.errors.keys)
      f.input :email, input_html: { readonly: true }
      f.input :name
      f.input :last_name
      f.input :role, as: :select, collection: User.roles.keys, include_blank: false
      f.input :latitude, as: :number, hint: '-34.44909'
      f.input :longitude, as: :number, hint: '-58.53176'
      # TODO: implement this
      # f.input :zone_id, as: :select, collection: Zone.all(&:name), include_blank: true
    end
    f.actions
  end
end
