import { DynamoDBClient, GetItemCommand } from '@aws-sdk/client-dynamodb';
import { env } from '../environment';

const dynamodb = new DynamoDBClient({region: "us-east-1"});

// Order table query function
export const getOrderById = async (orderId: string): Promise<any> => {
    const params = {
        TableName: 'orders',
        Key: {
            orderId: { S: orderId }
        }
    };
    try {
        const command = new GetItemCommand(params);
        const result = await dynamodb.send(command);
        return result.Item;
    } catch (error) {
        console.error('Error fetching order:', error);
        throw error;
    }
};

// Shipment table query function 
export const getShipmentByOrderId = async (orderId: string): Promise<any> => {
    const params = {
        TableName: 'shipments',
        Key: {
            orderId: { S: orderId }
        }
    };
    try {
        const command = new GetItemCommand(params);
        const result = await dynamodb.send(command);
        return result.Item;
    } catch (error) {
        console.error('Error fetching shipment:', error);
        throw error;
    }
};

// Local
const orderDb: Record<string, any> = {
    "12345": { status: "Shipped", items: ["Widget A", "Gadget B"], total: 150.00 },
    "67890": { status: "Processing", items: ["Gizmo C"], total: 75.50 },
};

const shipmentDb: Record<string, any> = {
    "12345": { carrier: "FastShip", trackingNumber: "FS123456789", status: "In Transit" },
};

// const productDb: Record<string, any> = {
//     "Widget A": { price: 50.00, stock: 100, description: "A fantastic widget" },
//     "Gadget B": { price: 100.00, stock: 50, description: "An amazing gadget" },
//     "Gizmo C": { price: 75.50, stock: 25, description: "A wonderful gizmo" },
// };

// Functions for tools
export const orderLookup = (orderId: string): any => {
    return env.ENV === "prod" ? getOrderById(orderId) : orderDb[orderId];
};
export const shipmentTracker = (orderId: string): any => {
    return env.ENV === "prod" ? getShipmentByOrderId(orderId) : shipmentDb[orderId];
};

export const returnProcessor = (orderId: string): string => `Return initiated for order ${orderId}`;

