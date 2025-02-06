package com.jeet.booking;

import com.jeet.api.Purchase;
import com.jeet.service.BookingHandlerImpl;
import jakarta.inject.Inject;

public class PurchaseDAO {

    @Inject
    private BookingHandlerImpl bookingHandler;

    public Purchase getBrainTreeCustomer(String uuid) throws InterruptedException {

        Purchase purchase = bookingHandler.getBrainTreeCustomerId(uuid);

        return purchase;
    }
}
