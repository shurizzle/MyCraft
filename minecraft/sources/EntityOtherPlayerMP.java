// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) braces deadcode 

package net.minecraft.src;


// Referenced classes of package net.minecraft.src:
//            EntityPlayer, MathHelper, InventoryPlayer, Item, 
//            ItemStack, World, DamageSource

public class EntityOtherPlayerMP extends EntityPlayer
{

    public EntityOtherPlayerMP(World world, String s)
    {
        super(world);
        field_35218_b = false;
        field_20924_a = 0.0F;
        username = s;
        yOffset = 0.0F;
        stepHeight = 0.0F;
        if(s != null && s.length() > 0)
        {
            skinUrl = (new StringBuilder()).append(gameSettings().skins_url).append(s).append(".png").toString();
        }
        noClip = true;
        field_22062_y = 0.25F;
        renderDistanceWeight = 10D;
    }

    protected void resetHeight()
    {
        yOffset = 0.0F;
    }

    public boolean attackEntityFrom(DamageSource damagesource, int i)
    {
        return true;
    }

    public void setPositionAndRotation2(double d, double d1, double d2, float f, 
            float f1, int i)
    {
        field_784_bh = d;
        field_783_bi = d1;
        field_782_bj = d2;
        field_780_bk = f;
        field_786_bl = f1;
        field_785_bg = i;
    }

    public void onUpdate()
    {
        field_22062_y = 0.0F;
        super.onUpdate();
        field_705_Q = field_704_R;
        double d = posX - prevPosX;
        double d1 = posZ - prevPosZ;
        float f = MathHelper.sqrt_double(d * d + d1 * d1) * 4F;
        if(f > 1.0F)
        {
            f = 1.0F;
        }
        field_704_R += (f - field_704_R) * 0.4F;
        field_703_S += field_704_R;
        if(!field_35218_b && func_35114_R() && inventory.mainInventory[inventory.currentItem] != null)
        {
            ItemStack itemstack = inventory.mainInventory[inventory.currentItem];
            func_35199_b(inventory.mainInventory[inventory.currentItem], Item.itemsList[itemstack.itemID].func_35411_c(itemstack));
            field_35218_b = true;
        } else
        if(field_35218_b && !func_35114_R())
        {
            func_35207_ac();
            field_35218_b = false;
        }
    }

    public float getShadowSize()
    {
        return 0.0F;
    }

    public void onLivingUpdate()
    {
        super.updateEntityActionState();
        if(field_785_bg > 0)
        {
            double d = posX + (field_784_bh - posX) / (double)field_785_bg;
            double d1 = posY + (field_783_bi - posY) / (double)field_785_bg;
            double d2 = posZ + (field_782_bj - posZ) / (double)field_785_bg;
            double d3;
            for(d3 = field_780_bk - (double)rotationYaw; d3 < -180D; d3 += 360D) { }
            for(; d3 >= 180D; d3 -= 360D) { }
            rotationYaw += d3 / (double)field_785_bg;
            rotationPitch += (field_786_bl - (double)rotationPitch) / (double)field_785_bg;
            field_785_bg--;
            setPosition(d, d1, d2);
            setRotation(rotationYaw, rotationPitch);
        }
        prevCameraYaw = cameraYaw;
        float f = MathHelper.sqrt_double(motionX * motionX + motionZ * motionZ);
        float f1 = (float)Math.atan(-motionY * 0.20000000298023224D) * 15F;
        if(f > 0.1F)
        {
            f = 0.1F;
        }
        if(!onGround || health <= 0)
        {
            f = 0.0F;
        }
        if(onGround || health <= 0)
        {
            f1 = 0.0F;
        }
        cameraYaw += (f - cameraYaw) * 0.4F;
        cameraPitch += (f1 - cameraPitch) * 0.8F;
    }

    public void outfitWithItem(int i, int j, int k)
    {
        ItemStack itemstack = null;
        if(j >= 0)
        {
            itemstack = new ItemStack(j, 1, k);
        }
        if(i == 0)
        {
            inventory.mainInventory[inventory.currentItem] = itemstack;
        } else
        {
            inventory.armorInventory[i - 1] = itemstack;
        }
    }

    public void func_6420_o()
    {
    }

    public float getEyeHeight()
    {
        return 1.82F;
    }

    private boolean field_35218_b;
    private int field_785_bg;
    private double field_784_bh;
    private double field_783_bi;
    private double field_782_bj;
    private double field_780_bk;
    private double field_786_bl;
    float field_20924_a;
}
