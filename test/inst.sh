#ansible-playbook --private-key ./compucorp-key.pem --extra-vars "gather_y_n=false" --skip-tags update_rep  Drupal.yml 
#ansible-playbook --private-key ./compucorp-key.pem --extra-vars "gather_y_n=false" --tags config_files  Drupal.yml 
#ansible-playbook --private-key ./compucorp-key.pem --extra-vars "gather_y_n=false" --tags deploy_templates  Drupal.yml 
ansible-playbook --private-key ./compucorp-key.pem --extra-vars "gather_y_n=false" --tags "make_links, deploy_templates" Drupal.yml 
#ansible-playbook --private-key ./compucorp-key.pem --extra-vars "gather_y_n=false" --tags "make_links"  Drupal.yml 

rm -f *.retry
