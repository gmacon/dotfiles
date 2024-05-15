let
  gmacon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF36+cqktTA1bjjg8/Q2j/CvftsE866fHT+XOji9rqCi";
  argon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9w24gcFFNkBgyFjliMV81VE3mLvQprpZAUa1aUrQTs";
  potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINvWjh1F36KqcmHaPJN8o8pK1f6d+oeBIShFdzKvT7T0";
in
{
  "tarsnap-ar.key.age".publicKeys = [ gmacon argon ];
  "tarsnap-k.key.age".publicKeys = [ gmacon potassium ];
}
