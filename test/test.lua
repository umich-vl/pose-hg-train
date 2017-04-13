--
-- User: hashimoto
-- Date: 2017/04/10
-- Time: 16:57
--

require 'torch'
require 'image'
require 'math'

function drawGaussian_old(img, pt, sigma)
    -- Draw a 2D gaussian
    -- Check that any part of the gaussian is in-bounds
    local tmpSize = math.ceil(3*sigma)
    local ul = {math.floor(pt[1] - tmpSize), math.floor(pt[2] - tmpSize)}
    local br = {math.floor(pt[1] + tmpSize), math.floor(pt[2] + tmpSize)}
    -- If not, return the image as is
    if (ul[1] > img:size(2) or ul[2] > img:size(1) or br[1] < 1 or br[2] < 1) then return img end
    -- Generate gaussian
    local size = 2*tmpSize + 1
    local g = image.gaussian(size)
    -- Usable gaussian range
    local g_x = {math.max(1, -ul[1]), math.min(br[1], img:size(2)) - math.max(1, ul[1]) + math.max(1, -ul[1])}
    local g_y = {math.max(1, -ul[2]), math.min(br[2], img:size(1)) - math.max(1, ul[2]) + math.max(1, -ul[2])}
    -- Image range
    local img_x = {math.max(1, ul[1]), math.min(br[1], img:size(2))}
    local img_y = {math.max(1, ul[2]), math.min(br[2], img:size(1))}
    assert(g_x[1] > 0 and g_y[1] > 0)
    img:sub(img_y[1], img_y[2], img_x[1], img_x[2]):cmax(g:sub(g_y[1], g_y[2], g_x[1], g_x[2]))
    return img
end

function drawGaussian_new(img, pt, sigma)
    -- Draw a 2D gaussian
    -- Check that any part of the gaussian is in-bounds
    local tmpSize = math.ceil(3*sigma)
    local _pt = {math.floor(pt[1]), math.floor(pt[2])} -- _pt is approximate of pt
    local ul = {_pt[1] - tmpSize, _pt[2] - tmpSize}
    local br = {_pt[1] + tmpSize, _pt[2] + tmpSize}
    -- If not, return the image as is
    if (ul[1] > img:size(2) or ul[2] > img:size(1) or br[1] < 1 or br[2] < 1) then return img end
    -- Generate gaussian
    local size = 2*tmpSize + 1
    local g = image.gaussian(size)
    -- Usable gaussian range
    local g_x = {math.max(1, 2-ul[1]), math.min(size,size-(br[1]-img:size(2)))}
    local g_y = {math.max(1, 2-ul[2]), math.min(size,size-(br[2]-img:size(1)))}
    -- Image range
    local img_x = {math.max(1, ul[1]), math.min(br[1], img:size(2))}
    local img_y = {math.max(1, ul[2]), math.min(br[2], img:size(1)) }
    assert(g_x[1] > 0 and g_y[1] > 0)
    img:sub(img_y[1], img_y[2], img_x[1], img_x[2]):cmax(g:sub(g_y[1], g_y[2], g_x[1], g_x[2]))
    return img
end

img=torch.zeros(10,10)
pt={1,1}
sigma=1

print("input of drawGaussian")
print("img:")
print(img)
print("pt")
print(pt)
print("sigma")
print(sigma)

img=drawGaussian_old(img,pt,sigma)
print("output of drawGaussian_old")
print(img)

img=torch.zeros(10,10)
pt={1,1}
sigma=1
img=drawGaussian_new(img,pt,sigma)
print("output of drawGaussian_new")
print(img)


