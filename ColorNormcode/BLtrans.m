% Beer-Lamber transformation

function V=BLtrans(I)

Ivecd=double(reshape(I,size(I,1)*size(I,2),size(I,3))); 
V=log(255)-log(Ivecd+1);  % V=WH, +1 is to avoid divide by zero
end